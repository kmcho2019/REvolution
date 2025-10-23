module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Combinational logic: shut_off_computer is high when CPU is overheated
    always @(*) begin
        shut_off_computer = cpu_overheated ? 1'b1 : 1'b0;
    end

    // Combinational logic: keep_driving is asserted only if not arrived and gas tank is not empty
    always @(*) begin
        if (~arrived)
            keep_driving = ~gas_tank_empty;
        else
            keep_driving = 1'b0;
    end

endmodule