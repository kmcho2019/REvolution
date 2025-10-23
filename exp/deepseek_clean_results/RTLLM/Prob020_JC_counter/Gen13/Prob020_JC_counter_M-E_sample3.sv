module JC_counter (
    input clk,
    input rst_n,
    input load,            // Parallel load enable
    input [63:0] data_in,  // Parallel load data
    output reg [63:0] Q     // Counter output
);

// Internal pipeline registers
reg [31:0] upper_stage;
reg [31:0] lower_stage;
reg load_reg;

// Clock gating control
wire clk_enable = !((Q == 64'h0) || (Q == 64'hFFFFFFFFFFFFFFFF));

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Synchronous reset
        Q <= 64'b0;
        upper_stage <= 32'b0;
        lower_stage <= 32'b0;
        load_reg <= 1'b0;
    end else if (clk_enable) begin
        // Register load signal
        load_reg <= load;
        
        if (load) begin
            // Parallel load operation
            Q <= data_in;
            upper_stage <= data_in[63:32];
            lower_stage <= data_in[31:0];
        end else begin
            // Pipelined Johnson counter operation
            // Stage 1: Process lower 32 bits
            lower_stage <= {~Q[0], Q[31:1]};
            
            // Stage 2: Process upper 32 bits
            upper_stage <= {~lower_stage[0], Q[63:32]};
            
            // Combine stages
            Q <= {upper_stage, lower_stage};
        end
    end
end

endmodule