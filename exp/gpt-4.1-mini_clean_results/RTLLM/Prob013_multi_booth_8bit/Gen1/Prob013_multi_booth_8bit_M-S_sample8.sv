module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [16:0] A;           // multiplicand extended by one bit for sign extension
    reg [16:0] P;           // product register (accumulator + multiplier + extra bit)
    reg [4:0] count;        // counts 4 iterations (2 bits per iteration)

    wire [2:0] booth_bits;  // 3 bits for Booth encoding (includes extra bit)

    // Extract the lowest 3 bits for Booth encoding from P
    assign booth_bits = P[2:0];

    // Booth encoding function to determine what to add/subtract
    function [16:0] booth_op;
        input [2:0] bits;
        begin
            case (bits)
                3'b000, 3'b111: booth_op = 17'd0;
                3'b001, 3'b010: booth_op =  A;
                3'b011:         booth_op =  A << 1;
                3'b100:         booth_op = - (A << 1);
                3'b101, 3'b110: booth_op = - A;
                default:        booth_op = 17'd0;
            endcase
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // sign-extend multiplicand (a) to 17 bits for arithmetic
            A <= {{9{a[7]}}, a};
            // initialize product register with multiplier (b) in lower bits and extra zero bit
            P <= {{8{b[7]}}, b, 1'b0};
            count <= 0;
            rdy <= 0;
            p <= 0;
        end else if (!rdy) begin
            // perform Booth operation: add/subtract according to booth_bits
            P <= (P >>> 2) + (booth_op(booth_bits) << 1); 
            // shift right arithmetic by 2 bits (>>>) to process next bits
            count <= count + 1;
            if (count == 4) begin
                // after processing 8 bits in 4 cycles, multiplication done
                p <= P[16:1];  // output the product (exclude the extra bit)
                rdy <= 1;
            end
        end
    end

endmodule