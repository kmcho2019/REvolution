module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state;
parameter IDLE = 2'b00;
parameter DETECTED = 2'b01;
parameter CONFIRMED = 2'b10;

always @(posedge clock) begin
    case (state)
        IDLE: begin
            if (a) begin
                state <= DETECTED;
                p <= 1;
                q <= 0;
            end
            else begin
                state <= IDLE;
                p <= 0;
                q <= 0;
            end
        end
        DETECTED: begin
            if (a) begin
                state <= CONFIRMED;
                p <= 1;
                q <= 1;
            end
            else begin
                state <= IDLE;
                p <= 0;
                q <= 0;
            end
        end
        CONFIRMED: begin
            if (a) begin
                state <= CONFIRMED;
                p <= 1;
                q <= 1;
            end
            else begin
                state <= IDLE;
                p <= 0;
                q <= 0;
            end
        end
        default: begin
            state <= IDLE;
            p <= 0;
            q <= 0;
        end
    endcase
end

endmodule