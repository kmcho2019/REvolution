module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // Binary encoded FSM states
    localparam IDLE   = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP   = 2'b10;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    wire terminal_count = (bit_count == 3'd7);

    // Assign done signal combinationally
    assign done = (state == STOP) && in;

    // Single always block for all sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (in == 0) begin
                        state <= RECEIVE;
                        bit_count <= 0;
                        shift_reg <= 0;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // Shift in LSB first
                    if (terminal_count) begin
                        state <= STOP;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end
                
                STOP: begin
                    if (in) begin
                        out_byte <= shift_reg;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule