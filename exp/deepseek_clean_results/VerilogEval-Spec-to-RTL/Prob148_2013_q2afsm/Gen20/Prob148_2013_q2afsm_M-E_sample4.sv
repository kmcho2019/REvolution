module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // Master FSM states
    localparam [1:0] IDLE = 2'b00;
    localparam [1:0] GRANT_0 = 2'b01;
    localparam [1:0] GRANT_1 = 2'b10;
    localparam [1:0] GRANT_2 = 2'b11;

    reg [1:0] master_state, next_master_state;
    reg [2:0] g_reg;

    // Mini-FSM for each device
    reg [0:0] fsm0_state, fsm1_state, fsm2_state;
    reg [0:0] next_fsm0, next_fsm1, next_fsm2;

    // Output assignment
    assign g = g_reg;

    // Master FSM sequential logic
    always @(posedge clk) begin
        if (!resetn) begin
            master_state <= IDLE;
            fsm0_state <= 0;
            fsm1_state <= 0;
            fsm2_state <= 0;
        end else begin
            master_state <= next_master_state;
            fsm0_state <= next_fsm0;
            fsm1_state <= next_fsm1;
            fsm2_state <= next_fsm2;
        end
    end

    // Master FSM combinational logic
    always @(*) begin
        // Default values
        next_master_state = master_state;
        next_fsm0 = fsm0_state;
        next_fsm1 = fsm1_state;
        next_fsm2 = fsm2_state;
        g_reg = 3'b000;

        case (master_state)
            IDLE: begin
                // Priority handling
                if (r[0]) begin
                    next_master_state = GRANT_0;
                    next_fsm0 = 1;
                end else if (r[1]) begin
                    next_master_state = GRANT_1;
                    next_fsm1 = 1;
                end else if (r[2]) begin
                    next_master_state = GRANT_2;
                    next_fsm2 = 1;
                end
            end

            GRANT_0: begin
                g_reg[0] = 1;
                if (!r[0]) begin
                    next_master_state = IDLE;
                    next_fsm0 = 0;
                end
            end

            GRANT_1: begin
                g_reg[1] = 1;
                if (!r[1]) begin
                    next_master_state = IDLE;
                    next_fsm1 = 0;
                end
            end

            GRANT_2: begin
                g_reg[2] = 1;
                if (!r[2]) begin
                    next_master_state = IDLE;
                    next_fsm2 = 0;
                end
            end
        endcase
    end

endmodule