module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [2:0] state;

    // Combinational next state logic using assign
    wire [2:0] next_state = (in) ? ((state < 3'd7) ? (state + 3'd1) : 3'd7) : 3'd0;

    // Output signals combinational logic
    wire disc_w = (state == 3'd5) && (in == 1'b0);
    wire flag_w = (state == 3'd6) && (in == 1'b0);
    wire err_w  = (next_state == 3'd7);

    // Sequential logic to update state and output signals
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