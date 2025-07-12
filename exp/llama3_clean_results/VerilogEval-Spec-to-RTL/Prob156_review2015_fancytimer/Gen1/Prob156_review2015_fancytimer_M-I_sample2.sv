module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] delay;
reg [3:0] remaining;
reg [3:0] shift_reg;
reg [2:0] state;
reg [9:0] counter;
reg [3:0] seq_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        delay <= 0;
        remaining <= 0;
        shift_reg <= 0;
        counter <= 0;
        count <= 0;
        counting <= 0;
        done <= 0;
        seq_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                seq_reg <= {seq_reg[2:0], data};
                if (seq_reg == 4'b1101) begin
                    state <= 1;
                    seq_reg <= 0;
                end
            end
            1: begin // SHIFT
                shift_reg <= {shift_reg[2:0], data};
                if (counter == 10'd3) begin
                    delay <= shift_reg;
                    state <= 2;
                    counter <= 0;
                    remaining <= delay + 1;
                end else begin
                    counter <= counter + 1;
                end
            end
            2: begin // COUNT
                counting <= 1'b1;
                if (counter == 10'd999) begin
                    counter <= 0;
                    remaining <= remaining - 1;
                    count <= remaining;
                    if (remaining == 0) begin
                        state <= 3;
                    end
                end else begin
                    counter <= counter + 1;
                    count <= remaining;
                end
            end
            3: begin // DONE
                done <= 1'b1;
                counting <= 0;
                if (ack == 1'b1) begin
                    state <= 0;
                    done <= 0;
                    delay <= 0;
                    remaining <= 0;
                    shift_reg <= 0;
                    counter <= 0;
                    count <= 0;
                end
            end
        endcase
    end
end

endmodule