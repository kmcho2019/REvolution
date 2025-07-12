module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // Booth encoding parameters
    localparam IDLE = 2'b00;
    localparam CALC = 2'b01;
    localparam DONE = 2'b10;
    
    reg [1:0] state;
    reg [3:0] counter;
    reg [31:0] partial_products [0:7];
    reg [31:0] sum, carry;
    
    // Booth encoder
    wire [16:0] bin_ext = {bin, 1'b0};
    wire [2:0] booth_bits [0:7];
    
    generate
        genvar i;
        for (i = 0; i < 8; i = i + 1) begin : booth_encoder
            assign booth_bits[i] = bin_ext[i*2+2:i*2];
        end
    endgenerate
    
    // Partial product generator
    always @(*) begin
        for (integer j = 0; j < 8; j = j + 1) begin
            case (booth_bits[j])
                3'b000, 3'b111: partial_products[j] = 32'b0;
                3'b001, 3'b010: partial_products[j] = {{16{ain[15]}}, ain} << (j*2);
                3'b011:         partial_products[j] = {{15{ain[15]}}, ain, 1'b0} << (j*2);
                3'b100:         partial_products[j] = -{{15{ain[15]}}, ain, 1'b0} << (j*2);
                3'b101, 3'b110: partial_products[j] = -{{16{ain[15]}}, ain} << (j*2);
            endcase
        end
    end
    
    // State machine and control logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            counter <= 4'b0;
            sum <= 32'b0;
            carry <= 32'b0;
            yout <= 32'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        state <= CALC;
                        counter <= 4'b0;
                        sum <= partial_products[0];
                        carry <= 32'b0;
                    end
                end
                
                CALC: begin
                    if (counter < 7) begin
                        // Carry-save addition
                        {carry, sum} <= {1'b0, sum} + {1'b0, carry} + {1'b0, partial_products[counter+1]};
                        counter <= counter + 1;
                    end else begin
                        // Final addition
                        yout <= sum + carry;
                        state <= DONE;
                        done <= 1'b1;
                    end
                end
                
                DONE: begin
                    if (!start) begin
                        state <= IDLE;
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule