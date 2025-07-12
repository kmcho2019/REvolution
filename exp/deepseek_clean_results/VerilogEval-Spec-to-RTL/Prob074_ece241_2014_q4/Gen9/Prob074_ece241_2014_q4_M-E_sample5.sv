module TopModule (
    input clk,
    input x,
    output reg z
);

    reg [1:0] state = 2'b00;
    reg dff_out = 1'b0;
    reg [2:0] history = 3'b000;
    
    always @(posedge clk) begin
        case (state)
            2'b00: begin  // XOR operation
                dff_out <= x ^ dff_out;
                history[0] <= dff_out;
                state <= 2'b01;
            end
            2'b01: begin  // AND operation
                dff_out <= x & ~dff_out;
                history[1] <= dff_out;
                state <= 2'b10;
            end
            2'b10: begin  // OR operation
                dff_out <= x | ~dff_out;
                history[2] <= dff_out;
                state <= 2'b00;
            end
        endcase
        
        // Update output z when all three operations are complete
        if (state == 2'b00) begin
            z <= ~(|history);
        end
    end

endmodule