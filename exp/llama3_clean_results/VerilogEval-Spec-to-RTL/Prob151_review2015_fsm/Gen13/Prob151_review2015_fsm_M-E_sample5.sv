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

// Pattern detection module
module pattern_detector(
    input  clk,
    input  reset,
    input  data,
    output reg pattern_detected
);

reg [3:0] pattern;
always @(posedge clk) begin
    if (reset) begin
        pattern <= 4'b0000;
        pattern_detected <= 1'b0;
    end else begin
        pattern[3:1] <= pattern[2:0];
        pattern[0] <= data;
        if (pattern == 4'b1101) begin
            pattern_detected <= 1'b1;
        end else begin
            pattern_detected <= 1'b0;
        end
    end
end

endmodule

// Pipelined state machine
reg [1:0] state;
reg [3:0] shift_count;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        shift_count <= 4'b0000;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (pattern_detected) begin
                    state <= 2'b01; // SHIFT
                end
            end
            2'b01: begin // SHIFT
                if (shift_count == 4'b1000) begin
                    state <= 2'b10; // COUNT
                end else begin
                    shift_count <= shift_count + 1'b1;
                end
            end
            2'b10: begin // COUNT
                if (done_counting) begin
                    state <= 2'b11; // DONE_ACK
                end
            end
            2'b11: begin // DONE_ACK
                if (ack) begin
                    state <= 2'b00; // IDLE
                end
            end
        endcase
    end
end

// Output assignments
assign shift_ena = (state == 2'b01);
assign counting = (state == 2'b10);
assign done = (state == 2'b11);

pattern_detector pd(
    .clk(clk),
    .reset(reset),
    .data(data),
    .pattern_detected(pattern_detected)
);

endmodule