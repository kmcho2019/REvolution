module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [2:0] state;
    reg [2:0] next_state;

    // Combinational next state calculation
    always @(*) begin
        if (in) begin
            if (state < 3'd7)
                next_state = state + 3'd1;
            else
                next_state = 3'd7;
        end else begin
            next_state = 3'd0;
        end
    end

    // Synchronous update of state and outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'd0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;
            // Outputs asserted one cycle after detection (Moore FSM)
            disc <= (state == 3'd5) && (in == 1'b0);
            flag <= (state == 3'd6) && (in == 1'b0);
            err  <= (next_state == 3'd7);
        end
    end

endmodule