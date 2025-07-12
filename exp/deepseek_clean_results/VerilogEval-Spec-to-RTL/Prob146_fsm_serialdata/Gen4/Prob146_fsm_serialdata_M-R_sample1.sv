module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // One-hot state encoding
    localparam IDLE    = 3'b001;
    localparam RECEIVE = 3'b010;
    localparam STOP    = 3'b100;

    reg [2:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    wire valid_stop;

    // Continuous assignment for done signal
    assign done = (state == STOP) && valid_stop;
    assign valid_stop = (in == 1'b1);

    // State transition logic (combinational)
    always @(*) begin
        case (state)
            IDLE:    state = (in == 1'b0) ? RECEIVE : IDLE;
            RECEIVE: state = (bit_count == 3'b111) ? STOP : RECEIVE;
            STOP:    state = valid_stop ? IDLE : STOP;
            default: state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                    if (in == 1'b0) begin
                        shift_reg <= 8'b0;  // Prepare for new byte
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // LSB first
                    bit_count <= bit_count + 1;
                end
                
                STOP: begin
                    if (valid_stop) begin
                        out_byte <= shift_reg;  // Capture byte on valid stop
                    end
                end
            endcase
        end
    end

endmodule