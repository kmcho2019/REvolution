module TopModule (
    input  cpu_overheated,
    output shut_off_computer,
    input  arrived,
    input  gas_tank_empty,
    output keep_driving
);

    always @(*) begin
        shut_off_computer = cpu_overheated;
        keep_driving = ~arrived & ~gas_tank_empty;
    end

endmodule