module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // Binary state encoding (2 bits)
    parameter [1:0] IDLE  = 2'b00;
    parameter [1:0] GRANT = 2'b01;

    // Grant tracking (2 bits: 00=none, 01=g0, 10=g1, 11=g2)
    reg [1:0] grant_reg;
    reg [1:0] state, next_state;

    // Priority encoder
    wire [1:0] priority_grant;
    assign priority_grant = r[0] ? 2'b01 : 
                          r[1] ? 2'b10 : 
                          r[2] ? 2'b11 : 2'b00;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (priority_grant != 0) ? GRANT : IDLE;
            end
            GRANT: begin
                // Stay in GRANT if current grantee still requesting
                next_state = (r[grant_reg-1]) ? GRANT : IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // State and grant tracking update
    always @(posedge clk) begin
        if (!resetn) begin
            state <= IDLE;
            grant_reg <= 0;
        end else begin
            state <= next_state;
            // Update grant only when transitioning to GRANT state
            if (state == IDLE && next_state == GRANT) begin
                grant_reg <= priority_grant;
            end else if (next_state == IDLE) begin
                grant_reg <= 0;
            end
        end
    end

    // Output generation
    assign g = (state == GRANT) ? 
              (grant_reg == 1 ? 3'b001 : 
               grant_reg == 2 ? 3'b010 : 
               grant_reg == 3 ? 3'b100 : 0) : 0;

endmodule