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
reg [9:0] counter;
reg [3:0] pattern;
reg start;

enum logic [2:0] {
    Idle,
    Pattern_Detected,
    Counting,
    Done
} state, next_state;

always @(*) begin
    case(state)
        Idle: next_state = (pattern == 4'b1101) ? Pattern_Detected : Idle;
        Pattern_Detected: next_state = (counter == 4) ? Counting : Pattern_Detected;
        Counting: next_state = (remaining == 0 && counter == 0) ? Done : Counting;
        Done: next_state = ack ? Idle : Done;
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= Idle;
        pattern <= 0;
        start <= 0;
        counter <= 0;
        counting <= 0;
        done <= 0;
        delay <= 0;
        remaining <= 0;
    end else begin
        case(state)
            Idle: begin
                if(data) begin
                    pattern <= {pattern[2:0], 1'b1};
                end else begin
                    pattern <= {pattern[2:0], 1'b0};
                end
                if(pattern == 4'b1101) begin
                    state <= Pattern_Detected;
                end
            end
            Pattern_Detected: begin
                delay <= {delay[2:0], data};
                counter <= counter + 1;
                if(counter == 4) begin
                    remaining <= delay + 1;
                    counter <= 0;
                    state <= Counting;
                end
            end
            Counting: begin
                counter <= counter + 1;
                if(counter == 1000) begin
                    counter <= 0;
                    remaining <= remaining - 1;
                end
                if(remaining == 0 && counter == 0) begin
                    state <= Done;
                end
            end
            Done: begin
                if(ack) begin
                    state <= Idle;
                end
            end
        endcase
        counting <= (state == Counting) ? 1'b1 : 1'b0;
        count <= (state == Counting) ? remaining : 4'bxxxx;
        done <= (state == Done) ? 1'b1 : 1'b0;
    end
end

endmodule