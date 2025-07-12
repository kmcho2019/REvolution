module TopModule (
    input clk,
    input x,
    output reg z
);

    reg [1:0] counter = 2'b00;  // Modulo-3 counter
    reg ff_out = 1'b0;          // Single flip-flop
    reg [2:0] gate_results;     // Storage for all three gate results

    always @(posedge clk) begin
        case (counter)
            2'b00: begin  // XOR phase
                ff_out <= x ^ ff_out;
                gate_results[0] <= x ^ ff_out;
            end
            2'b01: begin  // AND phase
                ff_out <= x & ~ff_out;
                gate_results[1] <= x & ~ff_out;
            end
            2'b10: begin  // OR phase
                ff_out <= x | ~ff_out;
                gate_results[2] <= x | ~ff_out;
                z <= ~(|gate_results);  // NOR output
            end
        endcase
        
        counter <= (counter == 2'b10) ? 2'b00 : counter + 1;
    end

endmodule