module TopModule (
    input  cpu_overheated,
    output reg shut_off_computer,
    input  arrived,
    input  gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        shut_off_computer = cpu_overheated;
    end

    always @(*) begin
        if (~arrived)
            keep_driving = ~gas_tank_empty;
        else
            keep_driving = 1'b0;
    end

endmodule