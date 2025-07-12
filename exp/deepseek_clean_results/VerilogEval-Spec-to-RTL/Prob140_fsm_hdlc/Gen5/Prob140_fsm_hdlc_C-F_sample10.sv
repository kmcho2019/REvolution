module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [2:0] count;
    reg disc_next, flag_next, err_next;

    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Register outputs
            disc <= disc_next;
            flag <= flag_next;
            err <= err_next;

            // Update counter
            if (in) begin
                if (count < 7)
                    count <= count + 1;
            end else begin
                count <= 0;
            end
        end
    end

    // Next state and output logic
    always @(*) begin
        // Default outputs
        disc_next = 0;
        flag_next = 0;
        err_next = 0;

        // Generate outputs
        if (count == 5 && !in) begin
            disc_next = 1;
        end else if (count == 6 && !in) begin
            flag_next = 1;
        end else if (count >= 6 && in) begin
            err_next = 1;
        end
    end

endmodule