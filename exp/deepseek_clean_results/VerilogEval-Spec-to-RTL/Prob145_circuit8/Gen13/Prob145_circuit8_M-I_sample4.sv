module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

// State encoding
localparam IDLE     = 2'b00;
localparam SAMPLING = 2'b01;
localparam LATCHED  = 2'b10;

reg [1:0] state;
reg a_sampled;

// Synchronous state machine
always @(posedge clock) begin
    case (state)
        IDLE: begin
            p <= a;
            if (a) begin
                state <= SAMPLING;
                a_sampled <= 1;
            end
        end
        
        SAMPLING: begin
            if (a_sampled && a) begin
                state <= LATCHED;
                q <= 1;
            end
            p <= a;
            a_sampled <= a;
        end
        
        LATCHED: begin
            p <= 0;
        end
    endcase
end

// Asynchronous reset condition
always @(a or clock) begin
    if (~clock && a && state != IDLE) begin
        state <= IDLE;
        q <= 0;
        p <= 0;
    end
end

initial begin
    state = IDLE;
    p = 0;
    q = 0;
    a_sampled = 0;
end

endmodule