module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline registers
    reg [15:0] mcand_ext;
    reg [15:0] partial_product;
    reg [15:0] accumulator;
    reg [3:0] counter;
    reg [1:0] booth_bits;
    reg prev_bit;
    reg zero_detect;

    // Shared arithmetic unit
    wire [15:0] pp_add = partial_product + mcand_ext;
    wire [15:0] pp_sub = partial_product - mcand_ext;
    wire [15:0] pp_add2 = partial_product + (mcand_ext << 1);
    wire [15:0] pp_sub2 = partial_product - (mcand_ext << 1);

    always @(posedge clk) begin
        if (reset) begin
            // Stage 1 initialization
            mcand_ext <= {{8{a[7]}}, a};
            partial_product <= 16'b0;
            booth_bits <= b[1:0];
            prev_bit <= 1'b0;
            
            // Stage 2 initialization
            accumulator <= 16'b0;
            counter <= 4'b0;
            zero_detect <= (b == 8'b0);
            rdy <= 1'b0;
        end else if (!rdy) begin
            // Pipeline Stage 1: Booth encoding and partial product generation
            case ({booth_bits, prev_bit})
                3'b000, 3'b111: partial_product <= 16'b0;
                3'b001, 3'b010: partial_product <= mcand_ext;
                3'b011: partial_product <= mcand_ext << 1;
                3'b100: partial_product <= -(mcand_ext << 1);
                3'b101, 3'b110: partial_product <= -mcand_ext;
            endcase
            
            // Update for next cycle
            booth_bits <= b[{counter+2'd2, counter+2'd1}];
            prev_bit <= booth_bits[0];
            mcand_ext <= mcand_ext << 2;
            
            // Pipeline Stage 2: Accumulation
            if (zero_detect) begin
                accumulator <= 16'b0;
                rdy <= 1'b1;
            end else begin
                case ({booth_bits, prev_bit})
                    3'b000, 3'b111: accumulator <= accumulator;
                    3'b001, 3'b010: accumulator <= accumulator + pp_add;
                    3'b011: accumulator <= accumulator + pp_add2;
                    3'b100: accumulator <= accumulator + pp_sub2;
                    3'b101, 3'b110: accumulator <= accumulator + pp_sub;
                endcase
                
                counter <= counter + 1;
                rdy <= (counter == 4'd3);
            end
        end
    end

    assign p = accumulator;

endmodule