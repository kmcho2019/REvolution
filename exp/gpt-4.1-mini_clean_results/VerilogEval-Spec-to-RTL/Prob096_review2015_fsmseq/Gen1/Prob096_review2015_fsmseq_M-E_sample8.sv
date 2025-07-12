module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire data,
    output reg  start_shifting
);

// One-hot state declarations
localparam IDLE = 5'b00001;
localparam S1   = 5'b00010;
localparam S11  = 5'b00100;
localparam S110 = 5'b01000;
localparam FOUND= 5'b10000;

reg [4:0] state, next_state;

// State register and output logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 1'b0;
    end else begin
        state <= next_state;
        if (start_shifting)
            start_shifting <= 1'b1;
        else if (next_state == FOUND)
            start_shifting <= 1'b1;
    end
end

// Next state combinational logic
always @(*) begin
    case (state)
        IDLE: begin
            if (data)
                next_state = S1;
            else
                next_state = IDLE;
        end

        S1: begin
            if (data)
                next_state = S11;
            else
                next_state = IDLE;
        end

        S11: begin
            if (data)
                next_state = S11;   // stay if another 1 comes
            else
                next_state = S110;
        end

        S110: begin
            if (data)
                next_state = FOUND; // sequence 1101 found
            else
                next_state = IDLE;
        end

        FOUND: begin
            next_state = FOUND; // latch here indefinitely until reset
        end

        default: next_state = IDLE;
    endcase
end

endmodule