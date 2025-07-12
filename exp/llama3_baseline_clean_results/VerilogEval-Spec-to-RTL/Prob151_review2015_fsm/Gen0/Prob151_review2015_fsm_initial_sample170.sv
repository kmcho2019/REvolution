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

reg [2:0] state; // IDLE, SHIFT, COUNT, DONE
reg [3:0] shift_count; // counter for shift bits
reg [3:0] pattern; // store the last 4 bits of data
reg [3:0] next_pattern;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        shift_count <= 0;
        pattern <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                pattern[3:1] <= pattern[2:0];
                pattern[0] <= data;
                next_pattern = {pattern[3], pattern[2], pattern[1], pattern[0]};
                if (next_pattern == 4'b1101) begin
                    state <= 1; // SHIFT
                    shift_count <= 1;
                end else begin
                    state <= 0; // stay in IDLE
                end
            end
            1: begin // SHIFT
                if (shift_count == 4) begin
                    state <= 2; // COUNT
                    shift_count <= 0;
                end else begin
                    shift_count <= shift_count + 1;
                end
            end
            2: begin // COUNT
                if (done_counting) begin
                    state <= 3; // DONE
                end else begin
                    state <= 2; // stay in COUNT
                end
            end
            3: begin // DONE
                if (ack) begin
                    state <= 0; // IDLE
                end else begin
                    state <= 3; // stay in DONE
                end
            end
        endcase
    end
end

assign shift_ena = (state == 1);
assign counting = (state == 2);
assign done = (state == 3);

endmodule