module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state;
localparam IDLE = 2'b00;
localparam P_ACTIVE = 2'b01;
localparam Q_ACTIVE = 2'b10;

always @(posedge clock) begin
    case (state)
        IDLE: begin
            if (a) begin
                p <= 1;
                state <= P_ACTIVE;
            end
            else begin
                p <= 0;
                state <= IDLE;
            end
            q <= 0;
        end
        
        P_ACTIVE: begin
            p <= a;
            if (p && !a) begin
                state <= Q_ACTIVE;
            end
            q <= 0;
        end
        
        Q_ACTIVE: begin
            q <= 1;
            p <= 0;
            if (!clock && a) begin
                state <= IDLE;
            end
            else begin
                state <= Q_ACTIVE;
            end
        end
        
        default: state <= IDLE;
    endcase
end

initial begin
    state = IDLE;
    p = 0;
    q = 0;
end

endmodule