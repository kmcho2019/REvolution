module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // Binary state encoding
    localparam IDLE  = 2'b00;
    localparam GRANT0 = 2'b01;
    localparam GRANT1 = 2'b10;
    localparam GRANT2 = 2'b11;
    
    reg [1:0] state, next_state;
    
    // Priority resolution signals
    wire grant0_req = r[0];
    wire grant1_req = r[1] & ~r[0];  // Only if higher priority not requesting
    wire grant2_req = r[2] & ~(|r[1:0]); // Only if no higher priorities
    
    // State register
    always @(posedge clk) begin
        if (!resetn) begin
            state <= IDLE;
            g <= 3'b000;
        end
        else begin
            state <= next_state;
            
            // Registered output generation
            case (next_state)
                IDLE:   g <= 3'b000;
                GRANT0: g <= 3'b001;
                GRANT1: g <= 3'b010;
                GRANT2: g <= 3'b100;
                default: g <= 3'b000;
            endcase
        end
    end
    
    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (grant0_req)       next_state = GRANT0;
                else if (grant1_req)  next_state = GRANT1;
                else if (grant2_req) next_state = GRANT2;
                else                 next_state = IDLE;
            end
            
            GRANT0: next_state = r[0] ? GRANT0 : IDLE;
            GRANT1: next_state = r[1] ? GRANT1 : IDLE;
            GRANT2: next_state = r[2] ? GRANT2 : IDLE;
            
            default: next_state = IDLE;
        endcase
    end

endmodule