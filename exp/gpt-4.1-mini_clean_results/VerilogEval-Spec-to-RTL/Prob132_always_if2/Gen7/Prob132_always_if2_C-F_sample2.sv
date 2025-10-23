module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Logic for shut_off_computer with default assignment
    always @(*) begin
        shut_off_computer = cpu_overheated ? 1'b1 : 1'b0;
    end

    // Logic for keep_driving with default assignment and simplified expression
    always @(*) begin
        if (!arrived)
            keep_driving = ~gas_tank_empty;
        else
            keep_driving = 1'b0;
    end

endmodule