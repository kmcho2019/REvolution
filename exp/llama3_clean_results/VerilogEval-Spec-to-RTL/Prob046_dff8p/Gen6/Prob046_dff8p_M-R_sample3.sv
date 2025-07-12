// Define a module for a single D flip-flop with synchronous reset
module DFF(
    input clk,
    input reset,
    input d,
    output q
);

reg q_reg;

always @(negedge clk) begin
    if(reset) begin
        q_reg <= 1'b0; // Reset bit
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule

// TopModule that instantiates 8 DFFs
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Define the reset vector
wire [7:0] reset_vec = 8'd52; // 0x34 in decimal is 52

// Instantiate 8 DFFs and apply the reset value
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin
        DFF dff_inst(
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .q(q[i])
        );
        
        // If reset is high, set the output of each DFF to the corresponding bit of the reset vector
        always @(negedge clk) begin
            if(reset) begin
                q[i] <= reset_vec[i];
            end
        end
    end
endgenerate

endmodule