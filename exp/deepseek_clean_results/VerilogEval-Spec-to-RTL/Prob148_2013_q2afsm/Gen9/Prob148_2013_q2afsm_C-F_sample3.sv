module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding with clear names
    localparam [1:0] STATE_A = 2'b00,  // Idle state
                     STATE_B = 2'b01,  // Grant to device 0
                     STATE_C = 2'b10,  // Grant to device 1
                     STATE_D = 2'b11;  // Grant to device 2

    reg [1:0] state;

    // Priority encoder - optimized version
    wire [1:0] next_grant;
    assign next_grant = r[0] ? STATE_B :  // Highest priority
                       r[1] ? STATE_C :  // Medium priority
                       r[2] ? STATE_D :  // Lowest priority
                       STATE_A;          // No request

    // State transitions - single always block
    always @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
        end else begin
            case (state)
                STATE_A: state <= next_grant;  // Grant highest priority request
                STATE_B: state <= r[0] ? STATE_B : STATE_A;  // Hold if request persists
                STATE_C: state <= r[1] ? STATE_C : STATE_A;  // Hold if request persists
                STATE_D: state <= r[2] ? STATE_D : STATE_A;  // Hold if request persists
                default: state <= STATE_A;
            endcase
        end
    end

    // Output generation - simple and efficient
    assign g = (state == STATE_B) ? 3'b001 :
               (state == STATE_C) ? 3'b010 :
               (state == STATE_D) ? 3'b100 :
               3'b000;

endmodule