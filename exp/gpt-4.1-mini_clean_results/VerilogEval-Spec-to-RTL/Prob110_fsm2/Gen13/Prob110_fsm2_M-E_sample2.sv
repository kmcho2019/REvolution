module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire j,
    input  wire k,
    output reg  out
);

    // Two-bit state encoding: only LSB used; MSB fixed to 0 for clarity/extensibility
    localparam [1:0] OFF = 2'b00;
    localparam [1:0] ON  = 2'b01;

    reg [1:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        if (state == OFF) begin
            if (j)
                next_state = ON;
            else
                next_state = OFF;
        end else begin // state == ON
            if (k)
                next_state = OFF;
            else
                next_state = ON;
        end
    end

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output register: Moore output is function of current state only
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b0;
        else
            out <= (state == ON);
    end

endmodule