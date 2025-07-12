module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

// Define a module for a single Processing Element (PE)
module PE (
    input left,
    input right,
    input center,
    output next_state
);
    assign next_state = left ^ right;
endmodule

// Systolic array of PEs
wire [511:0] next_state;
reg [511:0] q_reg;

genvar i;
generate
    for (i = 0; i < 512; i++) begin
        wire left, right, center;
        // Boundary conditions
        if (i == 0) begin
            assign left = 1'b0;
            assign right = (i == 511)? 1'b0 : q_reg[i + 1];
            assign center = q_reg[i];
        end else if (i == 511) begin
            assign left = q_reg[i - 1];
            assign right = 1'b0;
            assign center = q_reg[i];
        end else begin
            assign left = q_reg[i - 1];
            assign right = q_reg[i + 1];
            assign center = q_reg[i];
        end
        
        // Instantiate a PE for each cell
        PE pe (
            .left(left),
            .right(right),
            .center(center),
            .next_state(next_state[i])
        );
    end
endgenerate

// Sequential logic to update q_reg
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule