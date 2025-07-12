module TopModule(
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] q_reg; // Internal register to hold the shift register contents
assign q = q_reg; // Continuously assign the internal register to the output

always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset
        q_reg <= 4'b0000; // Reset the shift register to zero
    end else begin
        if (load) begin // Synchronous load
            q_reg <= data; // Load the data into the shift register
        end else if (ena) begin // Synchronous enable for shifting
            q_reg <= {1'b0, q_reg[3:1]}; // Shift the contents to the right
        end else begin
            q_reg <= q_reg; // If neither load nor ena is high, do nothing
        end
    end
end

endmodule