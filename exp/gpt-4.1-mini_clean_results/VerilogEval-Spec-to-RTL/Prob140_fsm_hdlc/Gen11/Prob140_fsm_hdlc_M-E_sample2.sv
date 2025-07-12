module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [2:0] state, next_state;

    // Next state logic
    always @(*) begin
        if (in == 1'b0) begin
            next_state = 3'd0;             // Reset count on zero input
        end else begin
            if (state < 3'd7)
                next_state = state + 3'd1; // Increment count of ones
            else
                next_state = 3'd7;         // Stay in error state if already there
        end
    end

    // Outputs logic (Moore type)
    wire disc_w = (state == 3'd5) && (in == 1'b0);
    wire flag_w = (state == 3'd6) && (in == 1'b0);
    wire err_w  = (next_state == 3'd7);

    // Sequential logic: state and registered outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'd0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;
            disc  <= disc_w;
            flag  <= flag_w;
            err   <= err_w;
        end
    end

endmodule