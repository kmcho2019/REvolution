module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        // Assign shut_off_computer explicitly for all cases
        if (cpu_overheated)
            shut_off_computer = 1'b1;
        else
            shut_off_computer = 1'b0;

        // Assign keep_driving explicitly for all cases
        if (~arrived && ~gas_tank_empty)
            keep_driving = 1'b1;
        else
            keep_driving = 1'b0;
    end

endmodule