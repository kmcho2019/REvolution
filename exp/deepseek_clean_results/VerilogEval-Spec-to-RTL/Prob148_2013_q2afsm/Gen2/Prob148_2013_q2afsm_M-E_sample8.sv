module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // FSM states
    parameter IDLE = 1'b0;
    parameter GRANTED = 1'b1;
    
    reg state;
    reg [1:0] current_grant; // 00: none, 01: g0, 10: g1, 11: g2
    
    // Priority encoder
    wire [1:0] priority_request;
    assign priority_request = r[0] ? 2'b01 : 
                             r[1] ? 2'b10 : 
                             r[2] ? 2'b11 : 2'b00;
    
    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (|r) begin
                    state = GRANTED;
                    current_grant = priority_request;
                end else begin
                    state = IDLE;
                    current_grant = 2'b00;
                end
            end
            GRANTED: begin
                case (current_grant)
                    2'b01: state = r[0] ? GRANTED : IDLE;
                    2'b10: state = r[1] ? GRANTED : IDLE;
                    2'b11: state = r[2] ? GRANTED : IDLE;
                    default: state = IDLE;
                endcase
            end
        endcase
    end
    
    // State storage
    always @(posedge clk) begin
        if (!resetn) begin
            state <= IDLE;
            current_grant <= 2'b00;
        end else begin
            state <= state;
            current_grant <= current_grant;
        end
    end
    
    // Output logic
    assign g[0] = (state == GRANTED) && (current_grant == 2'b01);
    assign g[1] = (state == GRANTED) && (current_grant == 2'b10);
    assign g[2] = (state == GRANTED) && (current_grant == 2'b11);

endmodule