module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

reg [2:0] state;
reg [3:0] shift_count;
assign shift_ena = (state == 3'b100);  // SHIFT state
assign counting = (state == 3'b101);   // COUNTING state
assign done = (state == 3'b110);      // DONE state

always @ (posedge clk) begin
    if (reset) begin
        state <= 3'b000;  // IDLE state
        shift_count <= 4'b0000;
    end else begin
        case (state)
            3'b000: begin  // IDLE state
                if (data) begin
                    state <= 3'b001;  // MATCH_1 state
                end else begin
                    state <= 3'b000;
                end
            end
            3'b001: begin  // MATCH_1 state
                if (data) begin
                    state <= 3'b010;  // MATCH_2 state
                end else begin
                    state <= 3'b000;  // back to IDLE state
                end
            end
            3'b010: begin  // MATCH_2 state
                if (~data) begin
                    state <= 3'b011;  // MATCH_3 state
                end else begin
                    state <= 3'b000;  // back to IDLE state
                end
            end
            3'b011: begin  // MATCH_3 state
                if (data) begin
                    state <= 3'b100;  // SHIFT state
                    shift_count <= 4'b0000;
                end else begin
                    state <= 3'b000;  // back to IDLE state
                end
            end
            3'b100: begin  // SHIFT state
                shift_count <= shift_count + 1;
                if (shift_count == 4'b1000) begin
                    state <= 3'b101;  // COUNTING state
                end else begin
                    state <= 3'b100;
                end
            end
            3'b101: begin  // COUNTING state
                if (done_counting) begin
                    state <= 3'b110;  // DONE state
                end else begin
                    state <= 3'b101;
                end
            end
            3'b110: begin  // DONE state
                if (ack) begin
                    state <= 3'b000;  // back to IDLE state
                end else begin
                    state <= 3'b110;
                end
            end
            default: state <= 3'b000;  // default to IDLE state
        endcase
    end
end

endmodule