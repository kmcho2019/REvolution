module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // State encoding
    localparam [1:0] IDLE   = 2'b00,
                     GRANT0 = 2'b01,
                     GRANT1 = 2'b10,
                     GRANT2 = 2'b11;

    reg [1:0] state, next_state;
    wire [1:0] req_type;
    wire req_valid;

    // Priority encoder - determines highest priority request
    assign req_valid = |r;
    assign req_type = r[0] ? 2'b00 : 
                     r[1] ? 2'b01 : 
                     r[2] ? 2'b10 : 2'b11;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = req_valid ? 
                            (req_type == 2'b00 ? GRANT0 :
                             req_type == 2'b01 ? GRANT1 : GRANT2) : IDLE;
            end
            GRANT0: next_state = r[0] ? GRANT0 : IDLE;
            GRANT1: next_state = r[1] ? GRANT1 : IDLE;
            GRANT2: next_state = r[2] ? GRANT2 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (!resetn) begin
            state <= IDLE;
            g <= 3'b000;
        end else begin
            state <= next_state;
            // Registered outputs for better timing
            case (next_state)
                GRANT0: g <= 3'b001;
                GRANT1: g <= 3'b010;
                GRANT2: g <= 3'b100;
                default: g <= 3'b000;
            endcase
        end
    end

endmodule