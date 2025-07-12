module TopModule (
    input  wire        clk,
    input  wire        resetn,
    input  wire [2:0]  r,
    output reg  [2:0]  g
);

    // One-hot state encoding for 4 states: A, B, C, D
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    reg [3:0] state, next_state;

    // Next-state combinational logic
    always @(*) begin
        // Default next state is current state
        next_state = state;

        // Decode current state signals for clarity
        wire inA = state == A;
        wire inB = state == B;
        wire inC = state == C;
        wire inD = state == D;

        // Priority signals for requests
        wire req0 = r[0];
        wire req1 = r[1];
        wire req2 = r[2];

        if (inA) begin
            if (req0)
                next_state = B;
            else if (req1)
                next_state = C;
            else if (req2)
                next_state = D;
            else
                next_state = A;
        end else if (inB) begin
            if (req0)
                next_state = B;
            else
                next_state = A;
        end else if (inC) begin
            if (req1)
                next_state = C;
            else
                next_state = A;
        end else if (inD) begin
            if (req2)
                next_state = D;
            else
                next_state = A;
        end else begin
            // Fallback reset to A
            next_state = A;
        end
    end

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Registered outputs to reduce glitches and improve timing/power
    always @(posedge clk) begin
        if (~resetn)
            g <= 3'b000;
        else begin
            case (state)
                A: g <= 3'b000;
                B: g <= 3'b001; // grant device 0
                C: g <= 3'b010; // grant device 1
                D: g <= 3'b100; // grant device 2
                default: g <= 3'b000;
            endcase
        end
    end

endmodule