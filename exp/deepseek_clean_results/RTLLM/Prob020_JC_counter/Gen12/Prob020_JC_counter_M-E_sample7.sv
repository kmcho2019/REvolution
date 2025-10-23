module JC_counter (
    input clk,
    input rst_n,
    input load,          // Parallel load enable
    input [63:0] data_in, // Parallel load data
    input direction,     // 0=forward (0000->1000...), 1=backward (0000->0001...)
    output reg [63:0] Q,
    output reg complete  // Pulses high for one cycle when cycle completes
);

reg [31:0] upper_reg;
reg [31:0] lower_reg;
reg prev_complete;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        upper_reg <= 32'b0;
        lower_reg <= 32'b0;
        complete <= 1'b0;
        prev_complete <= 1'b0;
    end
    else if (load) begin
        upper_reg <= data_in[63:32];
        lower_reg <= data_in[31:0];
        complete <= 1'b0;
        prev_complete <= 1'b0;
    end
    else begin
        // Detect completion (all 1s transitioning to all 0s)
        prev_complete <= (&upper_reg) & (&lower_reg);
        
        if (direction == 0) begin // Forward count
            upper_reg <= {~lower_reg[0], upper_reg[31:1]};
            lower_reg <= {~lower_reg[0], lower_reg[31:1]};
        end
        else begin // Backward count
            upper_reg <= {upper_reg[30:0], ~upper_reg[31]};
            lower_reg <= {lower_reg[30:0], ~upper_reg[31]};
        end
        
        // Generate one-cycle pulse on completion
        complete <= prev_complete & !(&upper_reg) & !(&lower_reg);
    end
end

// Combine the two registers for output
always @(*) begin
    Q = {upper_reg, lower_reg};
end

endmodule