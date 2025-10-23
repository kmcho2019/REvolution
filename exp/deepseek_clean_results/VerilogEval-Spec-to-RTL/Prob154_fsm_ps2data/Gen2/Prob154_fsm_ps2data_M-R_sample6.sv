module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    // State definitions
    localparam IDLE = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;
    
    reg [1:0] state, next_state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:   next_state = in[3] ? BYTE1 : IDLE;
            BYTE1:  next_state = BYTE2;
            BYTE2:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output byte collection (shift register style)
    always @(posedge clk) begin
        if (reset) begin
            out_bytes <= 24'b0;
        end else begin
            case (state)
                IDLE:   if (in[3]) out_bytes[23:16] <= in;
                BYTE1:  out_bytes[15:8] <= in;
                BYTE2:  out_bytes[7:0] <= in;
            endcase
        end
    end

    // Done signal is combinational
    assign done = (state == BYTE2);

endmodule