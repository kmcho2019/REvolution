module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [2:0] count;
    reg last_was_zero;
    wire next_disc, next_flag, next_err;

    // Combinational logic for next state and outputs
    always @(*) begin
        if (in) begin
            next_disc = 0;
            next_flag = 0;
            if (count >= 6)
                next_err = 1;
            else
                next_err = 0;
        end else begin
            next_err = 0;
            if (count == 5)
                next_disc = 1;
            else
                next_disc = 0;
            if (count == 6)
                next_flag = 1;
            else
                next_flag = 0;
        end
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
            last_was_zero <= 1;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Update counter and zero flag
            if (in) begin
                if (count < 7) count <= count + 1;
                last_was_zero <= 0;
            end else begin
                count <= 0;
                last_was_zero <= 1;
            end

            // Register outputs
            disc <= next_disc;
            flag <= next_flag;
            err <= next_err;
        end
    end

endmodule