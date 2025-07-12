module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // Register to store the current state

// Combinational logic to compute the next state
wire [511:0] next_state;
genvar i;
generate
    for (i = 0; i < 512; i++) begin
        wire left, center, right;
        if (i == 0) begin
            assign left = 1'b0; // Left boundary
        end else begin
            assign left = q_reg[i - 1];
        end
        
        assign center = q_reg[i];
        
        if (i == 511) begin
            assign right = 1'b0; // Right boundary
        end else begin
            assign right = q_reg[i + 1];
        end
        
        // Apply Rule 90
        assign next_state[i] = left ^ right;
    end
endgenerate

// Sequential logic to update the current state using a mux
assign q_reg = (load)? data : next_state;
always @(posedge clk) begin
    q_reg <= q_reg;
end

assign q = q_reg; // Output the current state

endmodule