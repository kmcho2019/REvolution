module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state;

// State definitions
localparam S_INIT  = 2'b00;
localparam S_PHIGH = 2'b01;
localparam S_QHIGH = 2'b10;
localparam S_RESET = 2'b11;

always @(posedge clock) begin
    case (state)
        S_INIT: begin
            if (a) begin
                state <= S_RESET;
                p <= 1;
                q <= 0;
            end
            else begin
                p <= 0;
                q <= 0;
                state <= S_INIT;
            end
        end
        
        S_PHIGH: begin
            p <= 0;
            q <= 1;
            state <= S_QHIGH;
        end
        
        S_QHIGH: begin
            if (a) begin
                state <= S_RESET;
                p <= 1;
                q <= 0;
            end
            else begin
                p <= 0;
                q <= 1;
                state <= S_QHIGH;
            end
        end
        
        S_RESET: begin
            if (a) begin
                state <= S_RESET;
                p <= 1;
                q <= 0;
            end
            else begin
                p <= 0;
                q <= 0;
                state <= S_INIT;
            end
        end
        
        default: state <= S_INIT;
    endcase
end

// Combinational output for immediate response to 'a' when q=0
always @(*) begin
    if (state == S_INIT && a) begin
        p = 1;
    end
    else if (state == S_QHIGH && a) begin
        p = 0;
    end
end

initial begin
    state = S_INIT;
    p = 0;
    q = 0;
end

endmodule