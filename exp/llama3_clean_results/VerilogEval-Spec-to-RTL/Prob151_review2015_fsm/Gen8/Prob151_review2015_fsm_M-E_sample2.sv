module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [3:0] pattern_reg;
reg pattern_detected;
reg shift_enable;
reg [1:0] shift_count;
reg counting_enable;
reg done_asserted;

// Pattern Detector
always @(posedge clk) begin
    if (reset) begin
        pattern_reg <= 4'b0000;
        pattern_detected <= 1'b0;
    end else begin
        pattern_reg[3:1] <= pattern_reg[2:0];
        pattern_reg[0] <= data;
        if (pattern_reg == 4'b1101) begin
            pattern_detected <= 1'b1;
        end else begin
            pattern_detected <= 1'b0;
        end
    end
end

// Shift Controller
always @(posedge clk) begin
    if (reset) begin
        shift_enable <= 1'b0;
        shift_count <= 2'b00;
    end else if (pattern_detected) begin
        shift_enable <= 1'b1;
        shift_count <= 2'b00;
    end else if (shift_enable && shift_count < 2'b11) begin
        shift_count <= shift_count + 1'b1;
    end else if (shift_enable && shift_count == 2'b11) begin
        shift_enable <= 1'b0;
    end
end

// Counter Monitor
always @(posedge clk) begin
    if (reset) begin
        counting_enable <= 1'b0;
    end else if (!shift_enable && shift_count == 2'b11) begin
        counting_enable <= 1'b1;
    end else if (done_counting) begin
        counting_enable <= 1'b0;
    end
end

// Acknowledgment Handler
always @(posedge clk) begin
    if (reset) begin
        done_asserted <= 1'b0;
    end else if (done_counting && !done_asserted) begin
        done_asserted <= 1'b1;
    end else if (ack && done_asserted) begin
        done_asserted <= 1'b0;
    end
end

// Output Logic
always @(*) begin
    shift_ena = shift_enable;
    counting = counting_enable;
    done = done_asserted;
end

endmodule