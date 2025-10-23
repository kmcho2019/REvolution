module TopModule (
    input clk,
    input x,
    output reg z
);

    reg [1:0] counter = 0;
    reg shared_ff = 0;
    reg xor_out = 0, and_out = 0, or_out = 0;

    always @(posedge clk) begin
        counter <= counter + 1;
        
        case (counter)
            2'b00: begin // XOR operation
                shared_ff <= x ^ shared_ff;
                xor_out <= shared_ff;
            end
            2'b01: begin // AND operation
                shared_ff <= x & ~shared_ff;
                and_out <= shared_ff;
            end
            2'b10: begin // OR operation
                shared_ff <= x | ~shared_ff;
                or_out <= shared_ff;
            end
        endcase
        
        z <= ~(xor_out | and_out | or_out);
    end

endmodule