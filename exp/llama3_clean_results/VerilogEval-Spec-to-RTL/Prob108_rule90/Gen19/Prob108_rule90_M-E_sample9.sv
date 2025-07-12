module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

// Systolic array architecture
wire [511:0] next_state;

genvar i;
generate
    for (i = 0; i < 512; i++) begin
        wire left, center, right;
        // Boundary conditions
        if (i == 0) begin
            assign left = 1'b0;
            assign center = q_reg[i];
            assign right = (i == 511)? 1'b0 : q_reg[i + 1];
        end else if (i == 511) begin
            assign left = q_reg[i - 1];
            assign center = q_reg[i];
            assign right = 1'b0;
        end else begin
            assign left = q_reg[i - 1];
            assign center = q_reg[i];
            assign right = q_reg[i + 1];
        end
        
        // Apply Rule 90 logic using a systolic array architecture
        wire [1:0] inputs;
        assign inputs[0] = left;
        assign inputs[1] = right;
        reg [1:0] output;
        always @(posedge clk) begin
            output <= inputs[0] ^ inputs[1];
        end
        assign next_state[i] = output[0];
    end
endgenerate

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule