module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [2:0] count;          // 3-bit counter for better state encoding
    reg [9:0] stage1_acc;     // First stage accumulator
    reg [9:0] stage2_acc;     // Second stage accumulator
    reg gated_clk;            // Gated clock signal
    
    // Clock gating logic
    always @(*) begin
        gated_clk = clk & (valid_in | (count != 0));
    end

    always @(posedge gated_clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            count <= 3'b000;
            stage1_acc <= 10'b0;
            stage2_acc <= 10'b0;
        end
        else if (valid_in) begin
            // Pipeline stage 1: Add new input
            stage1_acc <= stage2_acc + data_in;
            
            // Pipeline stage 2: Store intermediate result
            stage2_acc <= (count == 3'b011) ? 10'b0 : stage1_acc;
            
            // Update counter
            count <= (count == 3'b011) ? 3'b000 : (count + 1'b1);
        end
    end

    // Output logic (synchronous to main clock)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            valid_out <= (count == 3'b011) & valid_in;
            if ((count == 3'b011) & valid_in) begin
                data_out <= stage1_acc;
            end
        end
    end

endmodule