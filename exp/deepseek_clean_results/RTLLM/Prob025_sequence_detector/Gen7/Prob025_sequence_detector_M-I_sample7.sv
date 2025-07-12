module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// 3-bit shift register with state encoded in MSB
reg [3:0] shift_reg; // [3] is state, [2:0] stores last 3 bits
wire clk_gated;
reg gating_condition;

// Clock gating logic
assign clk_gated = clk & (~shift_reg[3] | gating_condition);

always @(*) begin
    gating_condition = (shift_reg[2:1] == 2'b10) & (data_in == 1'b0);
end

always @(posedge clk_gated or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 4'b0;
    end
    else begin
        // Shift register updates (state is shift_reg[3])
        shift_reg <= {shift_reg[2:0], data_in};
        
        // State transition (encoded in shift_reg[3])
        if (shift_reg[3]) begin // WAIT_FOR_LAST_1 state
            shift_reg[3] <= 1'b0; // Always return to IDLE
        end
        else if (shift_reg[1:0] == 2'b10 && data_in == 1'b0) begin
            shift_reg[3] <= 1'b1; // Transition to WAIT_FOR_LAST_1
        end
    end
end

// Two-stage pipelined output logic
reg detect_stage1;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        detect_stage1 <= 1'b0;
        sequence_detected <= 1'b0;
    end
    else begin
        detect_stage1 <= shift_reg[3] & data_in & (shift_reg[2:0] == 3'b100);
        sequence_detected <= detect_stage1;
    end
end

endmodule