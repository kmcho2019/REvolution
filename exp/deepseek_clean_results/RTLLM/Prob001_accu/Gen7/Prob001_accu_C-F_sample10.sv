module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;          // 0-3 counter (2 bits sufficient)
    reg [9:0] accu_reg;       // Shared accumulator/output register
    reg accu_valid;           // Pipeline stage valid flag

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            count <= 2'b00;
            accu_reg <= 10'b0;
            valid_out <= 1'b0;
            accu_valid <= 1'b0;
        end
        else begin
            // Default outputs
            valid_out <= 1'b0;

            // Pipeline stage 1: Accumulation
            if (valid_in) begin
                if (count == 2'b11) begin
                    // Final accumulation and prepare output
                    accu_reg <= accu_reg + data_in;
                    accu_valid <= 1'b1;
                    count <= 2'b00;
                end
                else begin
                    // Intermediate accumulation
                    accu_reg <= accu_reg + data_in;
                    count <= count + 1'b1;
                    accu_valid <= 1'b0;
                end
            end
            else begin
                accu_valid <= 1'b0;
            end

            // Pipeline stage 2: Output generation
            if (accu_valid) begin
                data_out <= accu_reg;
                valid_out <= 1'b1;
                accu_reg <= 10'b0;  // Clear for next accumulation
            end
        end
    end

endmodule