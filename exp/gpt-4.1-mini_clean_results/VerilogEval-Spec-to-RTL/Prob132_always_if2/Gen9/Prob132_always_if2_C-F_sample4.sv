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
        keep_driving      = 1'b0;

        // shut_off_computer is asserted if cpu_overheated is true
        if (cpu_overheated) begin
            shut_off_computer = 1'b1;
        end

        // keep_driving is true if not arrived and gas tank is not empty
        if (!arrived && !gas_tank_empty) begin
            keep_driving = 1'b1;
        end
    end

endmodule