module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    localparam S_0 = 0;   // Initial state or after seeing 0
    localparam S_ERR = 1; // Error state (7+ consecutive 1s)

    reg state, next_state;
    reg [2:0] count, next_count;
    reg disc_reg, flag_reg, err_reg;

    // Next state and counter logic
    always @(*) begin
        next_state = state;
        next_count = count;

        if (state == S_0) begin
            if (in) begin
                if (count < 6)
                    next_count = count + 1;
                else
                    next_state = S_ERR;
            end else begin
                next_count = 0;
            end
        end else begin // S_ERR
            if (!in) begin
                next_state = S_0;
                next_count = 0;
            end
        end
    end

    // Output logic (combinational)
    wire disc_next = (count == 5) && !in;
    wire flag_next = (count == 6) && !in;
    wire err_next  = (state == S_ERR);

    // State and output registration
    always @(posedge clk) begin
        if (reset) begin
            state <= S_0;
            count <= 0;
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg <= 1'b0;
        end else begin
            state <= next_state;
            count <= next_count;
            disc_reg <= disc_next;
            flag_reg <= flag_next;
            err_reg <= err_next;
        end
    end

    assign disc = disc_reg;
    assign flag = flag_reg;
    assign err = err_reg;

endmodule