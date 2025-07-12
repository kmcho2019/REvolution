module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        // Default assignments to avoid inferred latches
        shut_off_computer = 1'b0;
        keep_driving = 1'b0;

        // Logic for shut_off_computer
        if (cpu_overheated) begin
            shut_off_computer = 1'b1;
        end

        // Logic for keep_driving
        if (!arrived) begin
            if (!gas_tank_empty)
                keep_driving = 1'b1;
            else
                keep_driving = 1'b0;
        end else begin
            keep_driving = 1'b0;
        end
    end

endmodule