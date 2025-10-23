module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // FSM states: number of consecutive ones counted, saturates at 7 (7 or more)
    reg [3:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            4'd0: next_state = in ? 4'd1 : 4'd0;
            4'd1: next_state = in ? 4'd2 : 4'd0;
            4'd2: next_state = in ? 4'd3 : 4'd0;
            4'd3: next_state = in ? 4'd4 : 4'd0;
            4'd4: next_state = in ? 4'd5 : 4'd0;
            4'd5: next_state = in ? 4'd6 : 4'd0;
            4'd6: next_state = in ? 4'd7 : 4'd0;
            default: /* state==7 or above */ next_state = in ? 4'd7 : 4'd0;
        endcase
    end

    // Outputs combinational logic (Moore outputs depend only on state)
    wire disc_nxt = (state == 4'd5) && (in == 1'b0);
    wire flag_nxt = (state == 4'd6) && (in == 1'b0);
    wire err_nxt  = (state == 4'd7) && (in == 1'b1);

    // Registers with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= 4'd0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;

            // Output gating: only update outputs when changed to reduce toggling
            disc <= disc_nxt;
            flag <= flag_nxt;
            err  <= err_nxt;
        end
    end

endmodule