module TopModule(
    input  clk,
    input  areset,
    input  load,
    input  ena,
    input  [3:0] data,
    output [3:0] q
);

// Use a reg declaration with the correct width to store the shift register's state
reg [3:0] q_reg = 4'b0;

// Use an always block with a posedge clk trigger to update the shift register's state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset: set the shift register to zero
        q_reg <= 4'b0;
    end else begin
        // Synchronous logic: update the shift register based on load and ena signals
        if (load) begin
            // Load data into the shift register
            q_reg <= data;
        end else if (ena) begin
            // Shift the shift register to the right
            q_reg <= {1'b0, q_reg[3:1]};
        end
    end
end

// Assign the shift register's state to the output q
assign q = q_reg;

endmodule