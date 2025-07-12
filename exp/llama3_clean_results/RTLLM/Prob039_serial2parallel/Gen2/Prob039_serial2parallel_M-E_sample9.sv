module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [2:0] state;
reg [7:0] shift_register;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 3'b000;
        shift_register <= 8'b00000000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // Initial state
                if (din_valid) begin
                    state <= 3'b001;
                    shift_register <= {7'b0, din_serial};
                end else begin
                    state <= 3'b000;
                end
            end
            3'b001: begin // Receiving serial data
                if (din_valid) begin
                    shift_register <= {shift_register[6:0], din_serial};
                    if (state == 3'b111) begin
                        state <= 3'b000;
                        dout_parallel <= shift_register;
                        dout_valid <= 1'b1;
                    end else begin
                        state <= state + 1'b1;
                    end
                end else begin
                    state <= state;
                end
            end
            3'b010: begin
                if (din_valid) begin
                    shift_register <= {shift_register[6:0], din_serial};
                    state <= state + 1'b1;
                end else begin
                    state <= state;
                end
            end
            3'b011: begin
                if (din_valid) begin
                    shift_register <= {shift_register[6:0], din_serial};
                    state <= state + 1'b1;
                end else begin
                    state <= state;
                end
            end
            3'b100: begin
                if (din_valid) begin
                    shift_register <= {shift_register[6:0], din_serial};
                    state <= state + 1'b1;
                end else begin
                    state <= state;
                end
            end
            3'b101: begin
                if (din_valid) begin
                    shift_register <= {shift_register[6:0], din_serial};
                    state <= state + 1'b1;
                end else begin
                    state <= state;
                end
            end
            3'b110: begin
                if (din_valid) begin
                    shift_register <= {shift_register[6:0], din_serial};
                    state <= state + 1'b1;
                end else begin
                    state <= state;
                end
            end
            3'b111: begin // Output parallel data
                if (din_valid) begin
                    state <= 3'b000;
                    dout_parallel <= shift_register;
                    dout_valid <= 1'b1;
                end else begin
                    state <= state;
                end
            end
            default: begin
                state <= 3'b000;
            end
        endcase
    end
end

endmodule