module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [3:0] state;        // One-hot state: bit0=1st, bit1=2nd, bit2=3rd, bit3=4th
    reg [8:0] sum_stage1;   // First stage sum (9 bits for 2x8-bit sum)
    reg [9:0] sum_stage2;   // Final sum (10 bits)
    wire accu_enable;       // Clock gating signal

    assign accu_enable = valid_in && (state != 4'b1000);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 4'b0001;
            sum_stage1 <= 9'b0;
            sum_stage2 <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            valid_out <= 1'b0;
            
            if (valid_in) begin
                // State transition
                state <= {state[2:0], state[3]};
                
                // First stage accumulation (2 inputs at a time)
                if (state[0] || state[2]) begin
                    sum_stage1 <= data_in;
                end
                else begin
                    sum_stage1 <= sum_stage1 + data_in;
                end
                
                // Second stage accumulation
                if (state[1]) begin
                    sum_stage2 <= sum_stage1 + data_in;
                end
                
                // Output and reset on 4th input
                if (state[3]) begin
                    data_out <= sum_stage2 + data_in;
                    valid_out <= 1'b1;
                    sum_stage2 <= 10'b0;
                end
            end
        end
    end

endmodule