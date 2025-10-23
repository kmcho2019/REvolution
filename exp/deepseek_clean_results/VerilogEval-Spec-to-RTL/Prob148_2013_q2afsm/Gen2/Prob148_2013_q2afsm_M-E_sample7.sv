module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding
    localparam IDLE = 1'b0,
               GRANT = 1'b1;

    reg state, next_state;
    reg [1:0] current_grant, next_grant;

    // Priority encoder
    wire [1:0] priority_sel;
    assign priority_sel = r[0] ? 2'b00 : 
                         r[1] ? 2'b01 : 
                         r[2] ? 2'b10 : 
                                2'b11; // 11 means no request

    // State register
    always @(posedge clk) begin
        if (!resetn) begin
            state <= IDLE;
            current_grant <= 2'b11; // No grant
        end else begin
            state <= next_state;
            current_grant <= next_grant;
        end
    end

    // Next state and grant logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (priority_sel != 2'b11) begin
                    next_state = GRANT;
                    next_grant = priority_sel;
                end else begin
                    next_state = IDLE;
                    next_grant = 2'b11;
                end
            end
            GRANT: begin
                // Maintain grant if request still active
                if ((current_grant == 2'b00 && r[0]) ||
                    (current_grant == 2'b01 && r[1]) ||
                    (current_grant == 2'b10 && r[2])) begin
                    next_state = GRANT;
                    next_grant = current_grant;
                end else begin
                    next_state = IDLE;
                    next_grant = 2'b11;
                end
            end
            default: begin
                next_state = IDLE;
                next_grant = 2'b11;
            end
        endcase
    end

    // Output generation
    assign g[0] = (state == GRANT) && (current_grant == 2'b00);
    assign g[1] = (state == GRANT) && (current_grant == 2'b01);
    assign g[2] = (state == GRANT) && (current_grant == 2'b10);

endmodule