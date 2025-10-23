module TopModule(
    input ring,
    input vibrate_mode,
    output reg ringer,
    output reg motor
);

reg state;

always @(*) begin
    case (state)
        1'b0: begin // idle state
            if (ring) begin
                state = 1'b1;
            end else begin
                ringer = 0;
                motor = 0;
            end
        end
        1'b1: begin // ring state
            if (vibrate_mode) begin
                ringer = 0;
                motor = 1;
            end else begin
                ringer = 1;
                motor = 0;
            end
            if (~ring) begin
                state = 1'b0;
            end
        end
    endcase
end

initial begin
    state = 1'b0;
end

endmodule