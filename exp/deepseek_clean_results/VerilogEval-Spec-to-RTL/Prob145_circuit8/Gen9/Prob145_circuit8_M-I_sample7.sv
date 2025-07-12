module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state;
localparam IDLE  = 2'b00;
localparam P_HIGH = 2'b01;
localparam Q_SET = 2'b10;

always @(posedge clock) begin
    case (state)
        IDLE: begin
            if (a) begin
                state <= P_HIGH;
                p <= 1;
                q <= 0;
            end else begin
                p <= 0;
                q <= 0;
            end
        end
        P_HIGH: begin
            if (!a) begin
                state <= Q_SET;
                p <= 0;
                q <= 1;
            end else begin
                p <= 1;
            end
        end
        Q_SET: begin
            if (a) begin
                state <= P_HIGH;
                p <= 1;
                q <= 0;
            end else begin
                state <= IDLE;
                p <= 0;
                q <= 0;
            end
        end
        default: state <= IDLE;
    endcase
end

endmodule