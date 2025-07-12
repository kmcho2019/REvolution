module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state; // 0: IDLE, 1: PENDING, 2: ACTIVE
reg [2:0] counter;

always @(posedge clock) begin
    case (state)
        0: begin // IDLE
            if (a) begin
                state <= 1; // PENDING
                counter <= 1;
                p <= 0;
                q <= 0;
            end else begin
                state <= 0; // IDLE
                counter <= 0;
                p <= 0;
                q <= 0;
            end
        end
        1: begin // PENDING
            if (a) begin
                counter <= counter + 1;
                if (counter >= 2) begin
                    state <= 2; // ACTIVE
                    p <= 1;
                    q <= 0;
                end else begin
                    state <= 1; // PENDING
                    p <= 0;
                    q <= 0;
                end
            end else begin
                state <= 0; // IDLE
                counter <= 0;
                p <= 0;
                q <= 0;
            end
        end
        2: begin // ACTIVE
            if (a) begin
                state <= 2; // ACTIVE
                p <= 1;
                q <= 1;
            end else begin
                state <= 2; // ACTIVE
                p <= 0;
                q <= 1;
            end
        end
        default: begin
            state <= 0; // IDLE
            counter <= 0;
            p <= 0;
            q <= 0;
        end
    endcase
end

always @(negedge clock) begin
    if (!a) begin
        state <= 0; // IDLE
        counter <= 0;
        p <= 0;
        q <= 0;
    end
end

initial begin
    state = 0; // IDLE
    counter = 0;
    p = 0;
    q = 0;
end

endmodule