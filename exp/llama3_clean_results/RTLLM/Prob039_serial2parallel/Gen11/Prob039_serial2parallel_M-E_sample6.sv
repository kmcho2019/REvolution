module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [2:0] state;
reg [2:0] next_state;
reg [7:0] dout_parallel_next;
reg dout_valid_next;

// Gray counter
reg [2:0] cnt;
reg [2:0] cnt_next;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 3'b001; // idle state
        cnt <= 3'b000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else begin
        state <= next_state;
        cnt <= cnt_next;
        dout_parallel <= dout_parallel_next;
        dout_valid <= dout_valid_next;
    end
end

always @(*) begin
    next_state = state;
    cnt_next = cnt;
    dout_parallel_next = dout_parallel;
    dout_valid_next = dout_valid;

    case (state)
        3'b001: // idle state
            begin
                if (din_valid) begin
                    next_state = 3'b010; // receiving state
                    cnt_next = 3'b001;
                    dout_parallel_next = {7'b0, din_serial};
                    dout_valid_next = 1'b0;
                end else begin
                    next_state = 3'b001; // stay in idle state
                end
            end
        3'b010: // receiving state
            begin
                if (cnt == 3'b111) begin
                    next_state = 3'b001; // transition to idle state
                    cnt_next = 3'b000;
                    dout_valid_next = 1'b1;
                end else begin
                    next_state = 3'b010; // stay in receiving state
                    cnt_next = cnt + 3'b001;
                    dout_parallel_next = {dout_parallel[6:0], din_serial};
                end
            end
        default: ;
    endcase
end

endmodule